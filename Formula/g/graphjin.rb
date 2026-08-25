class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.56.tar.gz"
  sha256 "56aa92cfca81fe2685d13c8b830c0389a3db4858c400d9a8b2a679e7d2aecaba"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb30aeeb9f7b1276b829c6987d793c5f278910fcf1fe4908968c65fbba523b7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84ce8a859db1e5870d4c14682f1bb8f39c8f7f3505e2f66ef51b915313479ef7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d832c2934d80c3e08f5cd19ab16569c22ffd156de8aa7e9de5b01fd6e4857ab6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37a3bf3308f9e68a6b78b5d93fef4998d06db6f205d961fa014c601e9c4af7cf"
    sha256 cellar: :any,                 x86_64_linux:  "ab93f26195129f1beaa9129f5576c00835f0593b5f8a708009dd0b1a8aeb69a7"
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
