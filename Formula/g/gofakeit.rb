class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.8.1.tar.gz"
  sha256 "405f0c65bc0f9dc6f1f71b7596705935a856249c0cf5d5352c9f51adc88adaea"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9515980384e04ed57cf5758bf8c71a3dbeeceb5f4616788e252cb50c6f310148"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9515980384e04ed57cf5758bf8c71a3dbeeceb5f4616788e252cb50c6f310148"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9515980384e04ed57cf5758bf8c71a3dbeeceb5f4616788e252cb50c6f310148"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "727e059e9d717c63471b01bdfc20edc6dee4f645103cb6fa406faba4ca097c6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7fbb4336b2fb2d1a76b8e0f22f10c1274ace85b3950401f31b2db330efe79a8"
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
