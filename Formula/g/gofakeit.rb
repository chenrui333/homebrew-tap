class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.14.0.tar.gz"
  sha256 "98aa4a2228bb7b69027e68c6743ef06b826fdd11f8508138562e36a5bdee6968"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0f493dd94fe02b18fc32665a1f4baef9e97ba2077b2dcc13a3d1a252116b1ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0f493dd94fe02b18fc32665a1f4baef9e97ba2077b2dcc13a3d1a252116b1ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0f493dd94fe02b18fc32665a1f4baef9e97ba2077b2dcc13a3d1a252116b1ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3313d7a43c31c95ef8bdf4d5b9a27022ef647944ec83e07edf86dbaec61d1fbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd73b0cbd46f8dd4a7ecf77792095bc0d1371d68edcb810580612ca38af37519"
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
