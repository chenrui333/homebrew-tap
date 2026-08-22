class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "bda1335674e3e0fc7f2cc34f3b5aeffc0cf9144e639f82636103eba4427674fd"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "0c41a39c917b6c0514750687297e09c25ec3d7d3028835f90ef791ec8616da63"
    sha256               arm64_sequoia: "435591c078fb424543a8cc5a624dfce32aed93cc5bf142dad2060cdb82f18a46"
    sha256               arm64_sonoma:  "601450999c7ae46b4a4e3ed84ff7754ea84e1d4f9b882a2814789607b2f9cb18"
    sha256 cellar: :any, arm64_linux:   "760a66e7532950183117f4db4e442e351f9aff61fccc60bfcc818c3caac36ae6"
    sha256 cellar: :any, x86_64_linux:  "427d243b6da8deff110ee17a40ed5eac9625ce00f684f7387b27901a3c741bfe"
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
