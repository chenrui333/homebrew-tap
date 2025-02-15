class Code2prompt < Formula
  desc "CLI tool to convert your codebase into a single LLM prompt"
  homepage "https://github.com/mufeedvh/code2prompt"
  url "https://github.com/mufeedvh/code2prompt/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "cf08be573e816ebe8852cd8afa6fd122f6b5c00c081ac058ada326647cf8251c"
  license "MIT"
  head "https://github.com/mufeedvh/code2prompt.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "utils/linkage"

    assert_match version.to_s, shell_output("#{bin}/code2prompt --version")

    (testpath/"test.py").write <<~PYTHON
      def hello_world():
          print("Hello, world!")
    PYTHON

    output = shell_output("#{bin}/code2prompt --no-clipboard --json test.py")
    assert_match "ChatGPT models, text-embedding-ada-002", JSON.parse(output)["model_info"]

    [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"code2prompt", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
