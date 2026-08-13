class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.18.tar.gz"
  sha256 "29e79d30c9623d48fde7cd719d95995a9c533f799ce9f080f05bf242a314ddc4"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c41645f9238667bf718acb36a7dd726cd8058db3b9359eb83ab9311e356b2bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97b41e99c3b3d6e67e8df6e12eb20bc73df8f6de78748b5d7b5517bad79d8a4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a83fc9d441b9a4bf765b9c9d537b847836b2d97a9961a1613967d8988b0c3b8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8655b41bbf0a0ab097b89e7c0bc10ae63994afc637b1d49598dc5a171f5dc60"
    sha256 cellar: :any,                 x86_64_linux:  "eb284889cce9804fb91b152efc28e523f1f7874f69577af9777367b0cb4a18ab"
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
