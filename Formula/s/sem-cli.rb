class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "cc63eedf796127dbb8d980fe83a334d6b68d0b9325683b9a003fcff93af3de50"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e985caf7dad0e278c74378217a4c584e6d1d3bee3a180d1091c73864227fc5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "218e520d89cf16411f39628b64342960abb3aa5043405e2d81c9a58414358aa1"
    sha256 cellar: :any,                 arm64_linux:   "3c9d8cd3b0a7226f344f2da43d1ddce3423274bcd654010b47f4abdcb758f565"
    sha256 cellar: :any,                 x86_64_linux:  "9de3c795db1a5d147c3d85a89d1309c01e3a22651a66ae664e3d12705bd9cb65"
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
