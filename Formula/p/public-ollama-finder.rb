class PublicOllamaFinder < Formula
  desc "Discover and enumerate public Ollama LLM servers with detailed model data"
  homepage "https://github.com/zonay/public-ollama-finder"
  url "https://github.com/zonay/public-ollama-finder/archive/refs/tags/build-1.4.8.tar.gz"
  sha256 "47ad4656d0301ea6980030bb3e734ab56412f17b30e0150abf5501915e786b22"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"ip-ranges.txt").write "192.168.1.0/24"

    pipe_output("#{bin}/public-ollama-finder", "y", 0)
    # IP:Port,Model Name,Model,Modified At,Size,Digest,Parent Model,Format,Family,Parameter Size,Quantization Level
    assert_path_exists "llm_models.csv"
    # IP:Port,Tags URL,Status Code,Location
    assert_path_exists "ollama_endpoints.csv"
  end
end
