import gio.application : GioApplication = Application;
import gio.types : ApplicationFlags;
import gtk.application;
import gtk.application_window;
import gtk.button;
import gtk.hbox;
import gtk.label;
import glib.global;

import std.stdio : writeln;

class HelloWorld : ApplicationWindow
{
	this(Application application)
	{
		super(application);
		setTitle("giD");
		setBorderWidth(10);
		add(new Label("Hello World"));

		showAll();

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
		setBorderWidth(10);

		auto hbox = new HBox(false, 6);
		add(hbox);

    auto button = Button.newWithLabel("Click Me");
    button.connectClicked(&buttonClicked);
    hbox.add(button);

		showAll();
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
	application.connectActivate(delegate void(GioApplication app) { new HelloWorld(application); new TestLeak(application); });
	return application.run(args);
}
