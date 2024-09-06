pub const Instruction = enum(u8) {
    // Datatypes are only valid for constants
    NUMBER,
    STRING,
    CONSTANTS_DONE, // Marks end of constant definition
    CONSTANT,
    TRUE,
    FALSE,
    NIL,
    NOT,
    NEGATE,
    EQUAL,
    NOT_EQUAL,
    LESS,
    LESS_EQUAL,
    GREATER,
    GREATER_EQUAL,
    ADD,
    SUB,
    MUL,
    DIV,
    GLOBAL_DEFINE,
    GLOBAL_GET,
    GLOBAL_SET,
    LOCAL_GET,
    LOCAL_SET,
    LOCAL_SET_AT,
    LOCAL_POP,
    POP,
    PRINT,
    JUMP,
    JUMP_IF_FALSE,
};
