class Hazelnut < Formula
  desc "Terminal-based automated file organizer"
  homepage "https://github.com/ricardodantas/hazelnut"
  url "https://github.com/ricardodantas/hazelnut/archive/refs/tags/v0.2.49.tar.gz"
  sha256 "b5a56cdd717dab2fe6ca0442377b4b8bc375639531a82bddeff8ec1ad31520eb"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/ricardodantas/hazelnut.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hazelnut --version")

    downloads = testpath/"Downloads"
    downloads.mkpath

    config = testpath/"config.toml"
    config.write <<~TOML
      [[watch]]
      path = "#{downloads}"
      recursive = false

      [[rule]]
      name = "pdfs"

      [rule.condition]
      extension = "pdf"

      [rule.action]
      type = "move"
      destination = "#{testpath/"PDFs"}"
    TOML

    output = shell_output("#{bin}/hazelnut check --config #{config}")
    assert_match "Config is valid", output
    assert_match "1 watch paths", output
    assert_match "1 rules", output
    assert_match "pdfs", shell_output("#{bin}/hazelnut --config #{config} list")
  end
end
