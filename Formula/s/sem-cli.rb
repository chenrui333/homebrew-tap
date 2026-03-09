class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "08453cf7809510148db7c12c370bba18bd709aa15a38026aebd56d7f5e039bfa"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "144e3da5a586b07622aeafbde9a75c706c6f47837186d6c84f449aecd1f9a4da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9d16468250dafe9e6e6259a1d045446bba4273abb231be3b2401655d6835ec4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "311b2c2be859939974e4af5ee112d7493bfde47f9852718b1c19758e90a8179e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bded86a5ccbbae4d19a7b7d49f4123fb07f9673f65b99c43d751bb78d0fc2f43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a1f2a67c4108bfafe0a34795d13a34e6d2658dc62afa42a44f51a6da0c06d95"
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
