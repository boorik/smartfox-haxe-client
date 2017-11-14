package;
import utest.Assert;
class ConnectionTest
{
    var c:Client;
    var res:Bool;
    public function new(){}

    public function setup()
    {
        c = new Client("test");
        res = false;
    }

    function testConnection()
    {
        var done = Assert.createAsync(
            function()
            {
                trace('res : $res');
                Assert.isTrue(res);
            },
            3000);
        c.connect(function(b:Bool){
            res = b;
             trace('res : $res');
            done();
        });
    }
/* 
    function testLogin()
    {
        var done = Assert.createAsync(function(){},3000);
        c.connect(
            function(b:Bool)
            {
                Assert.isTrue(b);
                c.login("SimpleMMOWorld2",
                    function(b:Bool)
                    {
                        trace('login result : $b');
                        Assert.isTrue(b);
                        done();
                    }
                );
            }
        );
    }
    function testBadZoneLogin()
    {
        var done = Assert.createAsync(3000);
        c.connect(
            function(b:Bool)
            {
                Assert.isTrue(b);
                c.login("nonExistingZone",
                    function(b:Bool)
                    {
                        trace('login result : $b');
                        Assert.isTrue(b);
                        done();
                    }
                );
            }
        );
    } */
}