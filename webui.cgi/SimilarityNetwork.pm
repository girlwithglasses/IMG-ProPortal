package SimilarityNetwork;

use CGI qw( :standard );

sub getPageTitle {
    return 'Similarity Network';
}

sub getAppHeaderData {
    my($self) = @_;
    
    my @a = ( "getsme" );

    return @a;
}

############################################################################
# dispatch - Dispatch loop.
############################################################################
sub dispatch {
    my ( $self, $numTaxon ) = @_;

    my $html = <<END_HTML;
<script src="/js/d3.min.js" charset="utf-8"></script>
<script src="/js/sigma/sigma.min.js" charset="utf-8"></script>
<script src="/js/sigma/plugins/sigma.plugins.tooltips.min.js" charset="utf-8"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/mustache.js/0.8.1/mustache.min.js"></script>


<style>

#viewport {
  width: 1024px;
  height: 1024px;
  display: block;
  border: 1px solid black;
}
.sigma-tooltip {
  max-width: 240px;
  max-height: 280px;
  background-color: rgb(249, 247, 237);
  box-shadow: 0 2px 6px rgba(0,0,0,0.3);
  border-radius: 6px;
}
.sigma-tooltip-header {
  font-variant: small-caps;
  font-size: 120%;
  color: #437356;
  border-bottom: 1px solid #aac789;
  padding: 10px;
}
.sigma-tooltip-body {
  padding: 10px;
}
.sigma-tooltip-body th {
  color: #999;
  text-align: left;
}
.sigma-tooltip-footer {
  padding: 10px;
  border-top: 1px solid #aac789;
}
.sigma-tooltip > .arrow {
  border-width: 10px;
  position: absolute;
  display: block;
  width: 0;
  height: 0;
  border-color: transparent;
  border-style: solid;
}
.sigma-tooltip.top {
  margin-top: -12px;
}
.sigma-tooltip.top > .arrow {
  left: 50%;
  bottom: -10px;
  margin-left: -10px;
  border-top-color: rgb(249, 247, 237);
  border-bottom-width: 0;
}
.sigma-tooltip.bottom {
  margin-top: 12px;
}
.sigma-tooltip.bottom > .arrow {
  left: 50%;
  top: -10px;
  margin-left: -10px;
  border-bottom-color: rgb(249, 247, 237);
  border-top-width: 0;
}
.sigma-tooltip.left {
  margin-left: -12px;
}
.sigma-tooltip.left > .arrow {
  top: 50%;
  right: -10px;
  margin-top: -10px;
  border-left-color: rgb(249, 247, 237);
  border-right-width: 0;
}
.sigma-tooltip.right {
  margin-left: 12px;
}
.sigma-tooltip.right > .arrow {
  top: 50%;
  left: -10px;
  margin-top: -10px;
  border-right-color: rgb(249, 247, 237);
  border-left-width: 0;
}

</style>
<table><tr>
<td rowspan="2"><div id="viewport"></div></td>
<td valign="top">
<label for="color_by_selection">Color Nodes By:</label>
<select id="color_by_selection" onchange="updateColors()"></select>
<table id="legend">
</table>
</td>
</tr>
<tr><td><table id="metadata" border="1" style="display: none;"></table></td></tr>
</table>
<script src="/js/ABCSimilarityNetworkUI.js"></script>
END_HTML
    print $html;
}


1;
