class Weave < Formula
  desc "Entity-level semantic merge driver for Git"
  homepage "https://github.com/Ataraxy-Labs/weave"
  url "https://github.com/Ataraxy-Labs/weave/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "3efed8ae3e0bc4f5931bc564b6d49207f4c0f3e426f002d2be8096a4a91b2258"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/weave.git", branch: "main"

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
