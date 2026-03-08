class Ereandel < Formula
  desc "Gemini web browser using shell script"
  homepage "https://github.com/blmayer/ereandel"
  url "https://github.com/blmayer/ereandel/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "78bf4f35500ae9b1bc75ee22174cbdf2ff15eb694d9b46b9d3926ac943786201"
  license "MIT"
  head "https://github.com/blmayer/ereandel.git", branch: "main"

  def install
    inreplace "ereandel", 'version="0.26.0"', "version=\"#{version}\""

    bin.install "ereandel"
    man1.install "ereandel.en.1" => "ereandel.1"
    doc.install "README.md", "CONTRIBUTING.md"
    prefix.install_metafiles
  end

  test do
    (testpath/"sample.gmi").write <<~EOS
      # Hello
      => gemini://example.org Link
    EOS

    assert_match version.to_s, shell_output("#{bin}/ereandel --version")

    output = shell_output(
      "printf 'q' | HOME=#{testpath} XDG_CONFIG_HOME=#{testpath}/config XDG_CACHE_HOME=#{testpath}/cache " \
      "#{bin}/ereandel --file #{testpath}/sample.gmi 2>&1",
    )
    assert_match "Hello", output
    assert_match "gemini://example.org Link", output
  end
end
