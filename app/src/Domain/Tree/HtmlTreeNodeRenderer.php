<?php

declare(strict_types=1);

namespace App\Domain\Tree;

class HtmlTreeNodeRenderer implements TreeNodeRenderer
{
    public function render(TreeNode $node): string
    {
        $html = $this->renderNodeContent($node);
        
        if ($node->hasChildren()) {
            $html .= '<ul>';
            foreach ($node->getChildren() as $child) {
                $html .= '<li>' . $this->render($child) . '</li>';
            }
            $html .= '</ul>';
        }
        
        return $html;
    }

    private function renderNodeContent(TreeNode $node): string
    {
        $html = '<div><input type="checkbox"> ' . htmlspecialchars($node->getName());
        
        switch ($node->getType()) {
            case 'button':
                $html .= $this->renderButtonNode($node);
                break;
            case 'simple':
            default:
                // Simple node - no additional content
                break;
        }
        
        $html .= '</div>';
        
        return $html;
    }

    private function renderButtonNode(TreeNode $node): string
    {
        if (!$node instanceof ButtonNode) {
            return '';
        }
        
        $action = $node->getButtonAction();
        $buttonText = htmlspecialchars($node->getButtonText());
        
        if ($action) {
            return ' <br/> <button onclick="' . htmlspecialchars($action) . '">' . $buttonText . '</button>';
        }
        
        return ' <br/> <button>' . $buttonText . '</button>';
    }
} 