class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "3f491ba2fe6929e6e60ccc43af85fbae612e415182b84cd37aad9d680a1fe00e"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6cd6ba3b1a3e38a115c445a1fd0dc689a2323a6c92998d6d48ce638e7fb1516"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e45e5b934d56c58765ce7bf2af781f5b416597a470b419bf40e10dee3e3dea32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ca795eaf086a3f3bff8a784bb0a5d4b53bf7726abaad869c951a584d84c6ce8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dc1f61afc79c7b8968b62314c2cb1279a2f9542c09bd767fbfb2cdba4250ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29b4de41667877e0ffb31a30b6fad58a00134ae3c2848a35f7a873cfd5107abc"
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

    system bin/"graphjin", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
