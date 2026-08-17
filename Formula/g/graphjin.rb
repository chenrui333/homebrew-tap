class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.24.tar.gz"
  sha256 "330486d853f87d123109b90d5d05f14f053df5e7bb6261351ac3e1949d1626cb"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ef550d2e5594b81a5ff129254042544e4e8ffc270d4e64b095f7b53fb55186f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9aa43ee5cfa5e74da3edbd0877bf43bb780277f91b7b62a91bed3f26f8a01f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e857f587b8850073a7070ae57efbf88270c433485e26565f1aad51935d82611"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b39506e6da67db5e2a15e167f4bbe43cbf7a9473d67e85d6d35a63e76f9a400d"
    sha256 cellar: :any,                 x86_64_linux:  "6ee1ee7fded04927802746a40d5aa88286e1b16846600aa36f9e534b2e5011a3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X github.com/dosco/graphjin/serv/v3.version=#{version}
    ]

    cd "cmd" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"graphjin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graphjin version")

    system bin/"graphjin", "serve", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
