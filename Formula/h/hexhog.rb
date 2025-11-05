class Hexhog < Formula
  desc "Hex viewer/editor"
  homepage "https://github.com/DVDTSB/hexhog"
  url "https://github.com/DVDTSB/hexhog/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "d97176d41b9e9662909445a4002850f0ac12b902b28bc4e85a3b5bf983c93e61"
  license "MIT"
  head "https://github.com/DVDTSB/hexhog.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hexhog --version")

    # Fails in Linux CI with `No such device or address (os error 6)` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"

      (testpath/"testfile").write("Hello, Hexhog!")
      pid = spawn bin/"hexhog", testpath/"testfile", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "hexhog", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
