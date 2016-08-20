public class Window
{
protected int size;
Window()
{
size=1;
System.out.println("Window size="+size);
}
Window(int size)
{
this.size=size;
System.out.println("Window size="+size);
}
public void setSize(int x)
{size += x;}
public void printSize()
{System.out.println("Size=" + size);}
}
class MWindow extends Window
{
private String message = "No message";
MWindow(String message)
{
size = 2;
this.message = message;
System.out.println ("Window message = " + message);
}
public MWindow(int size, String message)
{
super(size);
this.message = message;
System.out.println ("Window message = " + message);
}
public void setSize1(int y)
{size = y;}
public void setSize2(int z)
{super.setSize (z);}
public void printSize()
{System.out.println ("MSize="+size);}
public void printSize1()
{System.out.println (super.size);}
public void printSize2()
{super.printSize();}
}
public class RunWindow
{
public static void main (String[] args)
{
Window w1=new Window();
Window w2=new Window(2);
System.out.println(w1.size);
System.out.println(w2.size);
}
}