import sys
import json
import argparse

# Isolate stdout so PyMuPDF warnings don't corrupt the JSON response
original_stdout = sys.stdout
sys.stdout = sys.stderr

try:
    import fitz  # PyMuPDF
    fitz.TOOLS.mupdf_display_errors(False)
except ImportError:
    original_stdout.write(json.dumps({"error": "PyMuPDF not installed. Run: pip install PyMuPDF"}))
    sys.exit(1)

def chunk_pdf(pdf_path, words_per_chunk=500):
    """
    Extracts text from a PDF and chunks it roughly by word count.
    This preserves context better than strictly chunking by page.
    """
    try:
        doc = fitz.open(pdf_path)
    except Exception as e:
        original_stdout.write(json.dumps({"error": str(e)}))
        sys.exit(1)

    full_text = ""
    for page in doc:
        text = page.get_text("text")
        if text:
            full_text += text + "\n"
    
    words = full_text.split()
    chunks = []
    
    for i in range(0, len(words), words_per_chunk):
        chunk = " ".join(words[i:i + words_per_chunk])
        chunks.append(chunk)

    return chunks

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Extract text chunks from PDF")
    parser.add_argument("--pdf", required=True, help="Absolute path to the PDF file")
    parser.add_argument("--chunk-size", type=int, default=500, help="Approximate words per chunk")
    args = parser.parse_args()

    chunks = chunk_pdf(args.pdf, args.chunk_size)
    
    # Output strictly as JSON so Dart can parse it from stdout
    output = {
        "status": "success",
        "total_chunks": len(chunks),
        "chunks": chunks
    }
    
    original_stdout.write(json.dumps(output))
