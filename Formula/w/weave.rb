class Weave < Formula
  desc "Entity-level semantic merge driver for Git"
  homepage "https://github.com/Ataraxy-Labs/weave"
  url "https://github.com/Ataraxy-Labs/weave/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "60c3cf0bacc7593d64ffde2d5d5720d93634e0c87778f4654a02b4903f00e8a4"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/weave.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c35c0c3dca623fac836919568e7a95ffecee8f1c9a707f9921b805d17caaba2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9f6e61e354a519f249410061851455740f444af1cb9bfba011bb27b4a91a57e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "243e898f97f6b9d3ab3c89f3913c28c8fbca21f72746b3142d2370e26a2608d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c65403b60cd476f89979eaccd26d4a7b365c43feacc5f39d9c3703e1a2581162"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f50374ce60ddfd3d3c86adfaa1f28388c3fbc8405c417238f982bd80b4ea6345"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libssh2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "crates/weave-cli")
    system "cargo", "install", *std_cargo_args(path: "crates/weave-driver")
  end

  test do
    system "git", "init"
    system bin/"weave", "setup"

    assert_equal "Entity-level semantic merge\n", shell_output("git config --get merge.weave.name")
    assert_match (bin/"weave-driver").to_s, shell_output("git config --get merge.weave.driver")
    assert_match "*.py merge=weave", (testpath/".gitattributes").read

    (testpath/"base.py").write <<~PYTHON
      def shared():
          return "base"
    PYTHON
    (testpath/"ours.py").write <<~PYTHON
      def shared():
          return "base"

      def greet():
          return "hello"
    PYTHON
    (testpath/"theirs.py").write <<~PYTHON
      def shared():
          return "base"

      def farewell():
          return "bye"
    PYTHON

    system bin/"weave-driver", "base.py", "ours.py", "theirs.py", "-o", "merged.py", "-p", "merged.py"
    merged = (testpath/"merged.py").read
    assert_match "def greet()", merged
    assert_match "def farewell()", merged
  end
end
