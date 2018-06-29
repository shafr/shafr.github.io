
* Get current Date
```bash
local DATE=`date '+%Y-%m-%d_%H-%M-%S'`
```

* Move list of files into target folder
```bash
mv -f -t ${REPORT_FOLDER}/${DATE} ${REPORT_FOLDER}/*.xml
```