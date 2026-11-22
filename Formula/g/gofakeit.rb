class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.18.11.tar.gz"
  sha256 "241aa603ed057c6f50310099f986440793042bfda7b9af93c8689f5daae4c2df"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "a422a0989a08202b2fbe5c6c6e5d0be8396a5b88661eeed9c561d24badc959ce"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc23238e6674b62a7096a4bc63f4b8844b932fc225b180717a7718ecf210e218"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc23238e6674b62a7096a4bc63f4b8844b932fc225b180717a7718ecf210e218"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3643f552bc921427a633b0abe5a46202bcbd6cd5139a168c53bc608836ecbfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4868dd22381f8e9de17b8a8a5c2f7abf1705b5f13d6d43693df635f28e220e27"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args, "./cmd/gofakeit"
  end

  test do
    system bin/"gofakeit", "street"
    system bin/"gofakeit", "school"
  end
end
