class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "90b22e7428e8873a3a715e02d1b3b4d53df8dadd6475b28c5b6e499d0dd84e0d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6e9fd3df2e08e0b07c3f30033ebf8a7006190e367f1dbdf7b2219f81f31119c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8ba33f49cd71641f6da27d237b4d12ea9a9fc09ed3899998bb6dfcdffeebf99"
    sha256 cellar: :any,                 arm64_linux:   "cc6e29b4923f5b1713bb576cdb20dd8f9c3a6afa5d231e2f7b6ec6d13a4d6a13"
    sha256 cellar: :any,                 x86_64_linux:  "ae702999d1b21acac52e5a5534c5d28c55a1bbd8855fa54b56ec3cbaa62cf05b"
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
