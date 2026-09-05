class Livediff < Formula
  desc "Watch file differences in the terminal"
  homepage "https://github.com/SoCkEt7/Livediff"
  url "https://github.com/SoCkEt7/Livediff/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "a813b9df67351cb4e401cdd6d483b907ad590f345a94fdd876e1c46e998df16e"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/SoCkEt7/Livediff.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/livediff --version")
    output = shell_output("#{bin}/livediff --invalid-option 2>&1", 2)
    assert_match "unexpected argument '--invalid-option'", output
  end
end
