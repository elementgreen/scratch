import gio.application : GioApplication = Application;
import gio.types : ApplicationFlags;
import gtk.application;
import gtk.application_window;
import gtk.button;
import gtk.box;
import gtk.label;
import gtk.types : Orientation;
import glib.global;

import std.stdio : writeln;

class HelloWorld : ApplicationWindow
{
  this(Application application)
  {
    super(application);
    setTitle("giD");
    setChild(new Label("Hello World"));

    import glib.global : timeoutAddSeconds;
    import glib.types : PRIORITY_DEFAULT, SOURCE_CONTINUE;
    import core.memory : GC;
    import std.stdio : writeln;
    timeoutAddSeconds(PRIORITY_DEFAULT, 1, () { writeln("GC.collect"); GC.collect; return SOURCE_CONTINUE; });
  }
}

class TestLeak : ApplicationWindow
{
  this(Application application)
  {
    super(application);
    setTitle("TestLeak");

    auto hbox = new Box(Orientation.Vertical, 6);
    setChild(hbox);

    auto button = Button.newWithLabel("Click Me");
    button.connectClicked(&buttonClicked);
    hbox.append(button);
  }

  void buttonClicked()
  {
    writeln("Button clicked!");
    close;
  }
}

int main(string[] args)
{
  auto application = new Application("org.gid.demo.helloworld", ApplicationFlags.FlagsNone);

  application.connectActivate(delegate void(GioApplication app) {
    auto helloWorld = new HelloWorld(application);
    auto testLeak = new TestLeak(application);

    helloWorld.present;
    testLeak.present;
  });

  return application.run(args);
}
