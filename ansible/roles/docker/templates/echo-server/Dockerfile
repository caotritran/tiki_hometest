FROM python:3-slim

WORKDIR /usr/src/app
COPY requirements.txt .

RUN pip3 install --no-cache-dir -r requirements.txt

COPY app.py .

#ENTRYPOINT ["./init.sh"]
EXPOSE 5000

ENV FLASK_DEBUG=1
ENV FLASK_APP=/usr/src/app/app.py

CMD ["python3", "-m", "flask", "run", "--host", "0.0.0.0"]
