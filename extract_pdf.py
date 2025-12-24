from pypdf import PdfReader

try:
    reader = PdfReader("Assessment Brief CMPN202 Operating Systems Coursework_v010 (2).pdf")
    text = ""
    for page in reader.pages:
        text += page.extract_text() + "\n"
    
    with open("instructions.txt", "w", encoding="utf-8") as f:
        f.write(text)
    print("Done")
except Exception as e:
    print(f"Error: {e}")
