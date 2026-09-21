#include <errno.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#define MAX_WORD_LENGTH 64
#define MAX_MAPPED_WORDS 10000
#define MAX_REDUCED_WORDS 4096

typedef struct {
    char word[MAX_WORD_LENGTH];
    unsigned count;
} WordCount;

static int is_ascii_alnum(int c)
{
    return (c >= 'A' && c <= 'Z') ||
           (c >= 'a' && c <= 'z') ||
           (c >= '0' && c <= '9');
}

static char ascii_lower(int c)
{
    if (c >= 'A' && c <= 'Z') {
        return (char)(c - 'A' + 'a');
    }
    return (char)c;
}

/* Returns 1 for a word, 0 at EOF and -1 for an overlong word. */
static int read_word(FILE *file, char word[], size_t capacity)
{
    int c;
    size_t length = 0;

    do {
        c = fgetc(file);
    } while (c != EOF && !is_ascii_alnum(c));

    if (c == EOF) {
        return 0;
    }

    do {
        if (length + 1 >= capacity) {
            do {
                c = fgetc(file);
            } while (c != EOF && is_ascii_alnum(c));
            return -1;
        }

        word[length++] = ascii_lower(c);
        c = fgetc(file);
    } while (c != EOF && is_ascii_alnum(c));

    word[length] = '\0';
    return 1;
}

static int map_file(FILE *file, WordCount mapped[], size_t capacity,
                    size_t *mapped_count)
{
    char word[MAX_WORD_LENGTH];
    int status;

    *mapped_count = 0;
    while ((status = read_word(file, word, sizeof(word))) == 1) {
        if (*mapped_count >= capacity) {
            fprintf(stderr, "Error: too many words for the prototype\n");
            return -1;
        }

        strcpy(mapped[*mapped_count].word, word);
        mapped[*mapped_count].count = 1;
        (*mapped_count)++;
    }

    if (status < 0) {
        fprintf(stderr, "Error: word exceeds %d characters\n",
                MAX_WORD_LENGTH - 1);
        return -1;
    }

    if (ferror(file)) {
        perror("fgetc");
        return -1;
    }

    return 0;
}

static int compare_by_word(const void *left, const void *right)
{
    const WordCount *a = left;
    const WordCount *b = right;
    return strcmp(a->word, b->word);
}

static int compare_for_output(const void *left, const void *right)
{
    const WordCount *a = left;
    const WordCount *b = right;

    if (a->count < b->count) {
        return 1;
    }
    if (a->count > b->count) {
        return -1;
    }
    return strcmp(a->word, b->word);
}

static size_t reduce_sorted(const WordCount mapped[], size_t mapped_count,
                            WordCount reduced[], size_t reduced_capacity)
{
    /*
     * TODO (núcleo da aula):
     * mapped já está ordenado por palavra. Produza em reduced uma entrada
     * por palavra distinta, somando as contagens iguais.
     */
    (void)mapped;
    (void)mapped_count;
    (void)reduced;
    (void)reduced_capacity;
    return 0;
}

static int parse_top_n(const char *text, size_t *top_n)
{
    char *end;
    unsigned long value;

    errno = 0;
    value = strtoul(text, &end, 10);
    if (errno == ERANGE || text[0] == '\0' || *end != '\0' || value == 0 ||
        value > SIZE_MAX) {
        return -1;
    }

    *top_n = (size_t)value;
    return 0;
}

int main(int argc, char *argv[])
{
    const char *input_path;
    size_t top_n = 10;
    size_t mapped_count;
    size_t reduced_count;
    size_t output_count;
    WordCount mapped[MAX_MAPPED_WORDS];
    WordCount reduced[MAX_REDUCED_WORDS];
    FILE *file;

    if (argc < 2 || argc > 3) {
        fprintf(stderr, "Usage: %s <input-file> [top-n]\n", argv[0]);
        return 1;
    }

    input_path = argv[1];
    if (argc == 3 && parse_top_n(argv[2], &top_n) != 0) {
        fprintf(stderr, "Error: top-n must be a positive integer: %s\n",
                argv[2]);
        return 1;
    }

    file = fopen(input_path, "r");
    if (file == NULL) {
        fprintf(stderr, "Error: cannot open input file '%s': ", input_path);
        perror("fopen");
        return 1;
    }

    if (map_file(file, mapped, MAX_MAPPED_WORDS, &mapped_count) != 0) {
        fclose(file);
        return 1;
    }
    fclose(file);

    qsort(mapped, mapped_count, sizeof(mapped[0]), compare_by_word);
    reduced_count = reduce_sorted(mapped, mapped_count, reduced,
                                  MAX_REDUCED_WORDS);
    if (reduced_count == SIZE_MAX) {
        fprintf(stderr, "Error: too many distinct words for the prototype\n");
        return 1;
    }

    qsort(reduced, reduced_count, sizeof(reduced[0]), compare_for_output);
    output_count = reduced_count < top_n ? reduced_count : top_n;

    printf("word,count\n");
    for (size_t i = 0; i < output_count; i++) {
        printf("%s,%u\n", reduced[i].word, reduced[i].count);
    }

    return 0;
}

