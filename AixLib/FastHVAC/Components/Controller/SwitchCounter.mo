within AixLib.FastHVAC.Components.Controller;
model SwitchCounter "Counts the number of switching events"

  Integer n_switch(start=0) "number of switching events";

  Modelica.Blocks.Interfaces.BooleanInput u "switching signal"
    annotation (Placement(transformation(extent={{-120,-30},{-80,10}}),
        iconTransformation(extent={{-100,-10},{-80,10}})));

initial equation
  pre(u) = false;

algorithm
  when (u and not
                 (pre(u))) then
         n_switch:=n_switch + 1;
  end when;

  annotation (
  Documentation(info="<html>
<dt><b>Description of the Switch Counter: </b>
<p> This model counts the number of times that the logical input <b>u</b> switches from 0 to 1 during the simulation time.
</p> 

<dl>
<dt><b>Main Author: </b>
<dd>Nicolas Chang (ssi-nch) <br>
    E.ON Energy Research Center <br>
    Institute for Energy Efficient Buildings and Indoor Climate <br>
    D-52066 Aachen <br>
    e-mail: <a href=\"mailto:nicolas.chang@eonerc.rwth-aachen.de\">nicolas.chang@eonerc.rwth-aachen.de</a><br>
</dl>
 
</html>", revisions="<html>
<p><ul>
<li><i>November 28, 2016&nbsp; </i> Tobias Blacha:<br/>Moved into AixLib</li>
</ul></p>
</html>"),
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                         graphics={Rectangle(
          extent={{-86,20},{92,-20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={215,215,215}), Text(
          extent={{-70,28},{88,-22}},
          lineColor={0,0,0},
          fontName="Square721 BT",
          textString="0|0|0|1|")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end SwitchCounter;
