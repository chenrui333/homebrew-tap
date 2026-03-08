class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt"
  homepage "https://filebrowser.org/"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.17.18.tar.gz"
  sha256 "5161f4affb98504f204cc23fb3c2a462486daf07b7d111ab9dda093152d55599"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df802c3cc5a54b79c11979e09bc3b3771fba7a1e43e0990958f40f30788a5a19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "042247eeffc57c23f7672a738cf4074af337827a84dd77b816efab9c66304cd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df802c3cc5a54b79c11979e09bc3b3771fba7a1e43e0990958f40f30788a5a19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9295dbca7cd8a6da764fa605bec7460dee963aefc63f4891f5eb81d9aa60988c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ad8612ac5535d0ad5b4454e36fe38843e761f54e9ae66097d1bbab49c3e359c"
  end

  depends_on "go" => :build
  depends_on "go-task" => :build
  depends_on "node" => :build

  def install
    system "task", "deps:fe", "build:fe"

    ldflags = %W[
      -s -w
      -X github.com/semaphoreui/semaphore/util.Ver=#{version}
      -X github.com/semaphoreui/semaphore/util.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "netgo"), "./cli"

    generate_completions_from_executable(bin/"semaphore", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/semaphore version")

    output = shell_output("#{bin}/semaphore users list 2>&1", 1)
    assert_match "Cannot Find configuration", output
  end
end
