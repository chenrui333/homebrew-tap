class Nom < Formula
  desc "RSS reader for the terminal"
  homepage "https://github.com/guyfedwards/nom"
  url "https://github.com/guyfedwards/nom/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "7bcd5052bd754a61e326d644d1094875fe51f174f94794583d1d1966575000e0"
  license "GPL-3.0-only"
  head "https://github.com/guyfedwards/nom.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a269ba06e7631793e1a963717aa3541abcca8af145802d36550a7336b2beefd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b000a013630febf6902afd36eb76ce65cd636d81585568239846a8d03817250f"
    sha256 cellar: :any_skip_relocation, ventura:       "cc432da6c8e0ed1f8af26e262d7101151ebcafd6c7023b1f5e8e0349fa94d591"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fd280ff1bae4a4e9cc22951385c3c00e1d46dce8301f0ab7d4117770b03992a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/nom"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nom version")

    assert_match "configpath", shell_output("#{bin}/nom config")
  end
end
