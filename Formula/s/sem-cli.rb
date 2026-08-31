class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "9cf030ad886a106aa26ba571e29d6b7de6b9ac37957a2f4ecea2989b91b56fb5"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "7b34dee2c6e561aacfd48838c4c64da6bc8fe418ac059845c8dff1fcd8513dba"
    sha256               arm64_sequoia: "71798b4aa071f932de438238e9634f8f53a8089858276f0eab5318de8a5d55eb"
    sha256               arm64_sonoma:  "5cb397b5e09fd3cb0d3a4bed545d2e569b25a3efb2ce9805b652a49922b97fd0"
    sha256 cellar: :any, arm64_linux:   "37c00bde2f9c31bf7feed9259a86b5255ad8b8f5d1379f0c4871da2f0ef5f6b3"
    sha256 cellar: :any, x86_64_linux:  "097a682739048281c070ee30c6a812802355612c1df24ae65092369fa6d6456a"
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
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "crates/sem-cli"), "--no-default-features"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sem --version")

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
