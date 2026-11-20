class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.18.10.tar.gz"
  sha256 "efc37b0f784d543c17b839894755cfb919f119f3318ac8c89ad65ef118421903"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc72635f93403f3b18a253e7e207d8d2df878962c09a9e5cf9a59311d2786a57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc72635f93403f3b18a253e7e207d8d2df878962c09a9e5cf9a59311d2786a57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9457b18cb61e926e8fb49fd1a38e72fcc27518b6730e8e873dce540a2d218e1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9920995d9147270ee110e0784801ca59cfb6c75e94584abc56ec63fc4d0e8e30"
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
