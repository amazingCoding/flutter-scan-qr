package io.xdag.plugin.scan_qr;

public class ResultEvent {
    private String result;

    public ResultEvent(String result) {
        this.result = result;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }
}
