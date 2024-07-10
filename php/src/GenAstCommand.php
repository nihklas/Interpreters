<?php

namespace Nkoll\Plox;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class GenAstCommand extends Command
{
    public function configure()
    {
        $this->setName('ast')
            ->setDescription('PHP Implementation of the Lox Interpreter')
            ->addArgument('output_dir', InputArgument::REQUIRED, 'Path to the .lox file to be interpreted');
    }

    public function execute(InputInterface $input, OutputInterface $output): int
    {
        $outputDir = $input->getArgument('output_dir');
        $this->defineAst($outputDir, "Expr", [
            "Binary   : Expr left, Token operator, Expr right",
            "Grouping : Expr expression",
            "Literal  : mixed value",
            "Unary    : Token operator, Expr right"
        ]);
        return Command::SUCCESS;
    }

    private function defineAst(string $outputDir, string $baseName, array $types): void
    {
        $path = "$outputDir/$baseName.php";

        $content = "<?php

namespace Nkoll\Plox\Lox;

abstract class $baseName
{
    abstract public function accept(Visitor \$visitor);
}
";

        $content .= $this->defineVisitor($baseName, $types);

        foreach ($types as $type) {
            [$classname, $fields] = explode(':', $type);
            $classname = trim($classname);
            $fields = trim($fields);
            $content .= $this->defineType($baseName, $classname, $fields);
        }

        file_put_contents($path, $content);
    }

    private function defineVisitor(string $basename, array $types): string
    {
        $content = "
interface Visitor
{
";
        foreach($types as $type) {
            $typeName = trim(explode(':', $type)[0]);
            $varName = strtolower($basename);
            $content .= "    public function visit$typeName$basename($typeName \$$varName);" . PHP_EOL;
        }

        $content .= "}";
        return $content;
    }

    private function defineType(string $basename, string $classname, string $fields): string
    {
        $fields = explode(', ', $fields);

        $fields = array_map(function ($field) {
            [$type, $name] = explode(' ', $field);
            return "        public $type \$$name,";
        }, $fields);
        $fields = implode(PHP_EOL, $fields);

        $content = "
class $classname extends $basename
{
    public function __construct(
$fields
    ) { }

    public function accept(Visitor \$visitor)
    {
        return \$visitor->visit$classname$basename(\$this);
    }
}
";

        return $content;
    }
}
