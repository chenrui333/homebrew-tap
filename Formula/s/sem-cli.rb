class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "b96e62f2c571ec8f6265ba7898054ebb77c99a7d8b2d871a41fee286e1cd6cf6"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c55f4615bad26a6dadab6912ed2acd2b260603e37afcf63d34e2cd3b3eef98da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0305d132362cc11678a512728955f05d30b738e334c301981655a6ef4905a2b"
    sha256 cellar: :any,                 arm64_linux:   "df9e2222170ca5ce656abc863a126a2c75e3e1f124d477c81c2b1a6ee47a4654"
    sha256 cellar: :any,                 x86_64_linux:  "2996091749f6b754f7068ee869f095e8e9958cedaf0199cf8744dfa602d34800"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libssh2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "parallel", because: "both install a sem executable"

  deny_network_access!

  def fetch
    cd "crates" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

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
