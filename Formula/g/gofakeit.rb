class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.0.0.tar.gz"
  sha256 "93469831881fa9c46c0032623570eaef185335b7116866246ab0c09186733058"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe058a16a32dc9e92808e0af178079061038fcba033ff0e7ede3ce6e7d404fa0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcd9a7004a26188cd1de5897b6cb686ff6e65328a27dbd15ecd3c153533ccec7"
    sha256 cellar: :any_skip_relocation, ventura:       "65fc761ddff28e7d4aee103584375bf1e8abf8d4affb7d06e344c6ee6dd1cbc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e93fd145af6b8d1d4f11360ff8ef5fbfde70b7e4d24d374fcac0169fabf830a2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gofakeit"
  end

  test do
    system bin/"gofakeit", "street"
    system bin/"gofakeit", "school"
  end
end
