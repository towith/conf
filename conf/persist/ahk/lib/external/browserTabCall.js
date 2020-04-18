const CDP = require('chrome-remote-interface');

var [proc, script, port, name, url, func, ...params] = process.argv;
let options = {
//    host: '127.0.0.1',
    port
};

var target;

async function openNewTab(url) {
    target = await CDP.New(options);
    const {Page} = await CDP({...options, target});
    await Page.enable();
    await Page.navigate({url});
    await Page.loadEventFired();
    return target;
}

function doInTarget(target) {
    console.log(target);
    options = {...options, id: target.id, target: target.id};
    client = CDP(options, (client) => {
        console.log('Connected!');
        try {
            const {Network, Page, Runtime} = client;
            /*
                        // setup handlers
                        Network.requestWillBeSent((params) => {
                            console.log(params.request.url);
                        });
            
                        // enable events then start!
                        Network.enable();
                        Page.enable();
                        Page.navigate({url: 'https://github.com'});
                        Page.loadEventFired();
            */
            var joinParams = "";
            params.map(p => {
                joinParams += '"' + p + '"' + ','
            });
            joinParams = joinParams.substring(0, joinParams.length - 1);
            if (params.length > 0) {
                Runtime.evaluate({
                    expression: func + '(' + joinParams + ')'
                });
            } else {
                Runtime.evaluate({expression: '' + func + '()'});
            }
            CDP.Activate(options, (err) => {
                if (!err) {
                    console.log('target is activated');
                }
            });
        } catch (err) {
            console.error(err);
        } finally {
            if (client) {
                client.close();
            }
        }
        //  
    }).on('error', (err) => {
        console.error(err);
    });
}

CDP.List(options, (err, targets) => {
    if (!err) {
        for (t of targets) {
            if (t.title.indexOf(name) == 0) {
                target = t;
                doInTarget(target);
                break;
            }
        }
        if (!target) {
            target = openNewTab(url).then(
                t => {
                    target = t;
                    doInTarget(target);
                }
            );
        }
    }
});







