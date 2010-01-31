#!/usr/bin/perl
#
# generator.pl
# dynamic generation of website pages using templates
#

use strict;

use HTML::Template;

use lib 'lib';
#use feed;

# Defaults
my $cLanguage = 'it';
my $cTmplPath = 'tmpl/'.$cLanguage;
my $cHtmlPath = 'html/'.$cLanguage;

# Website structure
my @aWebsite = (
    { page => 'home', title => 'Associazione Docenti Italiani di Filosofia'  },
    { page => 'consiglio_nazionale', title => 'Consiglio nazionale' },
    { page => 'lettera_segretaria', title => 'Lettera della segretaria nazionale' },
    { page => 'convegni', title => 'Convegni' },
    { page => 'convegno_2003', title => 'XIX Convegno Nazionale di Filosofia, settembre 2003, Cividale del Friuli' },
    { page => 'convegno_2005', title => 'XX Convegno Nazionale di Filosofia, ottobre 2005, Pescara' },
    { page => 'convegno_2007', title => 'XXI Convegno Nazionale di Filosofia, settembre 2007, Cividale del Friuli' },
    { page => 'fascicoli_monografici', title => 'Fascicoli monografici della rivista' },
    { page => 'giornate_kantiane', title => 'Giornate Kantiane' },
    { page => 'contatti', title => 'Contatti' },
    { page => 'info', title => 'Informazioni' },
    { page => 'statuto', title => 'Statuto' },
);

# Get next event (show in all pages)
#my $rItems = feed::getItems( feed::parse( 'rss/harmonia.rss' ) );
#my $cNextEvent = sprintf( '<a href="%s"><b><i>%s</i></b> - %s</a>', $rItems->[0]->{'link'}, substr( $rItems->[0]->{'title'}, 0, 10 ), substr( $rItems->[0]->{'title'}, 13 ) );

# Cicle structure and generate pages from templates
foreach my $rPage ( @aWebsite )
{
    my $cTemplate = $rPage->{'template'} || 'base';
    $cTemplate .= '.tmpl';

    my $oTmpl = HTML::Template->new( filename => $cTemplate, path => [ $cTmplPath ], debug => 1 );#, search_path_on_include => 0 );

    if( open( HTML, "> $cHtmlPath/$rPage->{'page'}.html" ) )
    {
        my @aLocaltime = localtime();

        $oTmpl->param( title => $rPage->{'title'},
#                       next_event => $cNextEvent,
                       content => getContent( $rPage->{'page'} ),
                       year => $aLocaltime[5] + 1900,
        );

        print HTML $oTmpl->output();
        close HTML;
    }
    else
    {
        print "Troubles!";
    }
}

sub getContent
{
    my $cPage = shift;

    my $cContent;

    if( open CONTENT, "$cTmplPath/$cPage.tmpl" )
    {
        $cContent = join( '', <CONTENT> );

        close CONTENT;
    }

    return $cContent;
}
