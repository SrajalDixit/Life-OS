from transformers import pipeline
sentiment_analyzer = pipeline("sentiment-analysis")

def analyze_sentiment(text: str) -> tuple[str, float]:
    result = sentiment_analyzer(text)[0]
    label = result['label'].lower()  # 'positive' or 'negative'
    score = result['score']
    return label, score
