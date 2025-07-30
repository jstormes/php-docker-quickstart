<?php

declare(strict_types=1);

namespace App\Application\Actions\Tree;

use App\Application\Actions\Action;
use App\Domain\Tree\SimpleNode;
use App\Domain\Tree\ButtonNode;
use App\Domain\Tree\HtmlTreeNodeRenderer;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class ViewTreeAction extends Action
{
    protected function action(): Response
    {
        // Build the tree structure using the new hierarchy
        $main = new ButtonNode('Main', 'Test Btn'); // Main has a button
        
        $sub1 = new SimpleNode('Sub-1');
        $sub2 = new SimpleNode('Sub-2');
        
        $sub21 = new SimpleNode('Sub-2-1');
        $sub22 = new SimpleNode('Sub-2-2');
        
        // Add children to Sub-2
        $sub2->addChild($sub21);
        $sub2->addChild($sub22);
        
        // Add children to Main
        $main->addChild($sub1);
        $main->addChild($sub2);
        
        // Generate HTML using the renderer
        $renderer = new HtmlTreeNodeRenderer();
        $treeHtml = '<div class="tree"><ul><li>' . $renderer->render($main) . '</li></ul></div>';
        
        $html = $this->generateHTML($treeHtml);
        
        $this->response->getBody()->write($html);
        return $this->response->withHeader('Content-Type', 'text/html');
    }
    
    private function generateHTML(string $treeHtml): string
    {
        $css = $this->getCSS();
        
        return <<<HTML
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Composite Pattern Tree</title>
    <style>
        {$css}
    </style>
</head>
<body>
    <h1>Composite Pattern Tree Implementation</h1>
    <p>This demonstrates the Composite design pattern with multiple node types.</p>
    {$treeHtml}
</body>
</html>
HTML;
    }
    
    private function getCSS(): string
    {
        return <<<CSS
.tree ul {
    padding-top: 20px; position: relative;
    
    transition: all 0.5s;
    -webkit-transition: all 0.5s;
    -moz-transition: all 0.5s;
}

.tree li {
    float: left; text-align: center;
    list-style-type: none;
    position: relative;
    padding: 20px 5px 0 5px;
    
    transition: all 0.5s;
    -webkit-transition: all 0.5s;
    -moz-transition: all 0.5s;
}

.tree li::before, .tree li::after{
    content: '';
    position: absolute; top: 0; right: 50%;
    border-top: 1px solid #ccc;
    width: 50%; height: 20px;
}
.tree li::after{
    right: auto; left: 50%;
    border-left: 1px solid #ccc;
}

.tree li:only-child::after, .tree li:only-child::before {
    display: none;
}

.tree li:only-child{ padding-top: 0;}

.tree li:first-child::before, .tree li:last-child::after{
    border: 0 none;
}
.tree li:last-child::before{
    border-right: 1px solid #ccc;
    border-radius: 0 5px 0 0;
    -webkit-border-radius: 0 5px 0 0;
    -moz-border-radius: 0 5px 0 0;
}
.tree li:first-child::after{
    border-radius: 5px 0 0 0;
    -webkit-border-radius: 5px 0 0 0;
    -moz-border-radius: 5px 0 0 0;
}
.tree ul ul::before{
    content: '';
    position: absolute; top: 0; left: 50%;
    border-left: 1px solid #ccc;
    width: 0; height: 20px;
}
.tree li div{
    border: 1px solid #ccc;
    padding: 5px 10px;
    text-decoration: none;
    color: #666;
    font-family: arial, verdana, tahoma;
    font-size: 11px;
    display: inline-block;
    
    border-radius: 5px;
    -webkit-border-radius: 5px;
    -moz-border-radius: 5px;
    
    transition: all 0.5s;
    -webkit-transition: all 0.5s;
    -moz-transition: all 0.5s;
}
.tree li div:hover, .tree li div:hover+ul li div {
    background: #c8e4f8; color: #000; border: 1px solid #94a0b4;
}
.tree li div:hover+ul li::after, 
.tree li div:hover+ul li::before, 
.tree li div:hover+ul::before, 
.tree li div:hover+ul ul::before{
    border-color:  #94a0b4;
}

body {
    font-family: Arial, sans-serif;
    margin: 20px;
    background-color: #f5f5f5;
}

h1 {
    color: #333;
    text-align: center;
    margin-bottom: 10px;
}

p {
    text-align: center;
    color: #666;
    margin-bottom: 30px;
}
CSS;
    }
} 