class Ereandel < Formula
  desc "Gemini web browser using shell script"
  homepage "https://github.com/blmayer/ereandel"
  url "https://github.com/blmayer/ereandel/archive/refs/tags/v0.26.2.tar.gz"
  sha256 "deadb0a59a18178695a016dd1648957ac8146516a9f6488bbdd8123d47175eab"
  license "MIT"
  head "https://github.com/blmayer/ereandel.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "1a38095e47b70925db9c249330d0d11406467a483e32e20c237d91e8cb3fe4b6"
  end

  def install
    inreplace "ereandel", /^version=".*"$/, "version=\"#{version}\""

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
      1,
    )
    assert_match "Hello", output
    assert_match "gemini://example.org Link", output
  end
end
