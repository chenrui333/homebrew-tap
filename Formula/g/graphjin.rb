class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.35.tar.gz"
  sha256 "a8dd1a78e6f449e8d3f56f079320eba5f77ca49b7afc0d3c3ce96b24611c2819"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7526b2a42df3a4d3380ab73cdcf0d50321a2f52cd7097d81f85ca5c3e464ec61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a3847d83ba98547413edfb65eba679e26c8eff0f3ef88ce370cfc87dc8cccd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4975ab79a8ec137af45487b2caf0c5860fc838030d33d78510a08a050f30f59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10d012623dff601c976553cbb3ec54e456b4e88b52e0f5d38a6c1254d08ebef6"
    sha256 cellar: :any,                 x86_64_linux:  "aad18665e989a781947a55ba3db9b25104f7771d16b4aca7d718c29ca9c885d5"
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
