class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.5.0.tar.gz"
  sha256 "7f83e825a187db19d5a7f0786989cb0a52baec51ec4c7c6d529a09a9536d83f7"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e89529f1fcf0b9ae82e212bb0bd5c5ab83b912ae7d395563824f43fe23336e57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cdd71cc9628e31f22b83c4095d8e55fc0bf8c1c0da9bf0c9b8bdcfa1bb5eaa0"
    sha256 cellar: :any_skip_relocation, ventura:       "308bfb51c3f62ee6936e7a318b703fe2cf5e4f4daf9f815c6ddb23205a2254e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a3b8dbe0f6aa4aec3856e0cbd301fbd9203e3fda781e1d1f579df669534e78f"
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
