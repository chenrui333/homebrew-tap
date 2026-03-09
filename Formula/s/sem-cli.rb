class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "c52f96433958c403ed53886b596a8df76387d37919bee3b9d925dc4f11d4b88d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d98ff1d3c0b494ae2fd1e579b7eaf449fe5cb3746711755d55238a2cb01c6962"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8eec2c32cb26721db721814070d46f0074a161833dfd9e01090d121d35b5c7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21b7bf35dbd0bf81fce2d3c046c1882e8d9bec02796f51e1aa7a9eda88111736"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77d5f584cf25d632ace19aa4fc106d9d94cf60f0d5f9ff5cf2f32e16d479329a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f56a4ea6ab2d0429dbe0b6dac54ba8b2c46dc04f4ca83d6da25709e380357baf"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libssh2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "parallel", because: "both install a sem executable"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "crates/sem-cli")
  end

  test do
    system "git", "init"
    system "git", "config", "user.email", "test@example.com"
    system "git", "config", "user.name", "Test User"
    (testpath/"hello.py").write <<~PYTHON
      def greet():
          print("hello")
    PYTHON
    system "git", "add", "hello.py"
    system "git", "commit", "-m", "init"

    output = shell_output("#{bin}/sem diff --commit HEAD --format json")
    json = JSON.parse(output)
    assert_equal 1, json["changes"].length
    assert_equal "function", json["changes"][0]["entityType"]
    assert_equal "greet", json["changes"][0]["entityName"]
  end
end
