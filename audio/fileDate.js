const Max = require('max-api');
const path = require('path');
const fs = require('fs');

Max.addHandler("getFiles", async (dirPath) => {
	try {
		Max.outlet("clear");

		const files = await fs.promises.readdir(dirPath);
		const fileStats = [];

		for (const file of files) {
			if (!file.toLowerCase().endsWith('.wav')) continue;

			const fullPath = path.join(dirPath, file);
			const stats = await fs.promises.stat(fullPath);
			if (stats.isFile()) {
				fileStats.push({ path: fullPath, birthtime: stats.birthtime });
			}
		}
		
		if (fileStats.length === 0) return;

		fileStats.sort((a, b) => b.birthtime - a.birthtime);

		fileStats.forEach((file, index) => {
			Max.outlet(["append", file.path]);
		});

		Max.outlet("dump");
		Max.outlet(0);
	} catch (error) {
		// Max.post(`Error in getFiles for "${dirPath}": ${error.message}`);
	}
});

Max.addHandler("maxFiles", async (dirPath, maxCount) => {
	try {
		const files = await fs.promises.readdir(dirPath);
		const fileStats = [];

		for (const file of files) {
			const fullPath = path.join(dirPath, file);
			const stats = await fs.promises.stat(fullPath);
			if (stats.isFile()) {
				fileStats.push({ path: fullPath, birthtime: stats.birthtime });
			}
		}

		if (fileStats.length > maxCount) {
			fileStats.sort((a, b) => a.birthtime - b.birthtime);
			const excess = fileStats.length - maxCount;
			const toRemove = fileStats.slice(0, excess);

			for (const file of toRemove) {
				await fs.promises.unlink(file.path);
				// Max.post(`Removed: ${file.path}`);
			}
		}
	} catch (error) {
		// Max.post(`Error in maxFiles for "${dirPath}": ${error.message}`);
	} finally {
		Max.outlet(`bang`);
	}
});
