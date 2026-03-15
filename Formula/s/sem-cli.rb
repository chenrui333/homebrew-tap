class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.3.10.tar.gz"
  sha256 "97fcceab5745204001526220f6e207925466e49489d3af4cc76b9219a59b5a97"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8490c68a9695e7fd5109544a68ea9cc22a097d7f9ad95e6051ed09f2f7c4fb3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c98908d19d946157fca270f40c3d71dbb0e212a0952f8d46be1b17f29ca2a1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d65cd70f3a850361a2c61e133dfe3f7ee50f23ba1350b3d41a96cb91bd7a6fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bb54cd416644adfebc9eb1c317dde348368c8b8987e88e23f4785a07fb32beb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dc9d1c67d01c94db32a190d890e58bffce22962eae78569d9c7d8be46a6ceaa"
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
