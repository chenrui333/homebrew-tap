class Weave < Formula
  desc "Entity-level semantic merge driver for Git"
  homepage "https://github.com/Ataraxy-Labs/weave"
  url "https://github.com/Ataraxy-Labs/weave/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "60c3cf0bacc7593d64ffde2d5d5720d93634e0c87778f4654a02b4903f00e8a4"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/weave.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65a8e93a2ac4019cca3b3433d088efbb36c793ac7c4ee4cfc6936ef8d8462ee1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aedb948fc1519e5da801c54f4fb516980dd06655db005ee9b02df1324f6ca5d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd718472e2590f696268e5b693aafc6300d000c97ace0a1b61b5202522e01786"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91c01ce93248a1812d55c7c12840df6701641bf863b785641648381e06598347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12e66e0c73b52a34fc3b29601991cb53874e6790b24acbb94515505c62c385d1"
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
