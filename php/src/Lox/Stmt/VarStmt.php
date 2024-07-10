<?php

namespace Nkoll\Plox\Lox\Stmt;

use Nkoll\Plox\Lox\Token;
use Nkoll\Plox\Lox\Expr\Expr;

class VarStmt extends Stmt
{
    public function __construct(
        public Token $name,
        public ?Expr $initializer,
    ) { }

    public function accept(StmtVisitor $visitor)
    {
        return $visitor->visitVarStmt($this);
    }
}
