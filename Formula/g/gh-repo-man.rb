class GhRepoMan < Formula
  desc "Manage GitHub repositories interactively from the terminal"
  homepage "https://github.com/2KAbhishek/gh-repo-man"
  url "https://github.com/2KAbhishek/gh-repo-man/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "beb6eb8664422e5663be00ff782545f859a21828ab0a388092040c1fb4c9e9f0"
  license "MIT"
  head "https://github.com/2KAbhishek/gh-repo-man.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ed808f1a002e50f0a2156aeec52c85c58b9c88d801c0472ee8b6d902a30cd95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ed808f1a002e50f0a2156aeec52c85c58b9c88d801c0472ee8b6d902a30cd95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ed808f1a002e50f0a2156aeec52c85c58b9c88d801c0472ee8b6d902a30cd95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22a78bb12b0115ffa1789efdcb4b54f057e97750a11bfbd35afe086a693716f8"
    sha256 cellar: :any,                 x86_64_linux:  "909f18b1970da1ed9e00c9e767ab448d8b951e77bcc5505ec7e581ea2cf8b16c"
  end

  depends_on "go" => :build
  depends_on "fzf"
  depends_on "gh"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    testbin = testpath/"test-bin"
    testbin.mkpath

    gh = testbin/"gh"
    gh.write <<~SH
      #!/bin/sh
      if [ "$1" = "repo" ] && [ "$2" = "list" ]; then
        cat <<'JSON'
      [{"name":"sample-repo","description":"Sample repository","url":"https://github.com/brewtest/sample-repo","stargazerCount":3,"forkCount":1,"watchers":{"totalCount":2},"issues":{"totalCount":0},"owner":{"login":"brewtest"},"createdAt":"2025-01-01T00:00:00Z","updatedAt":"2025-01-02T00:00:00Z","diskUsage":42,"homepageUrl":"","isFork":false,"isArchived":false,"isPrivate":false,"isTemplate":false,"repositoryTopics":[],"primaryLanguage":{"name":"Go"}}]
      JSON
        exit 0
      fi
      if [ "$1" = "api" ] && [ "$2" = "user" ]; then
        echo '{"login":"brewtest"}'
        exit 0
      fi
      echo "unexpected gh invocation: $*" >&2
      exit 1
    SH

    fzf = testbin/"fzf"
    fzf.write <<~SH
      #!/bin/sh
      IFS= read -r first_line
      printf '%s\n' "$first_line"
    SH

    git = testbin/"git"
    git.write <<~SH
      #!/bin/sh
      if [ "$1" = "clone" ]; then
        mkdir -p "$3/.git"
        exit 0
      fi
      echo "unexpected git invocation: $*" >&2
      exit 1
    SH

    chmod 0755, [gh, fzf, git]
    ENV.prepend_path "PATH", testbin

    home = Pathname(Dir.home)
    config_dir = home/".config"/"gh-repo-man"
    config_dir.mkpath
    config = config_dir/"config.yml"
    config.write <<~YAML
      repos:
        projects_dir: #{home/"projects"}
        per_user_dir: false
      integrations:
        post_clone:
          enabled: false
    YAML

    output = shell_output("#{bin}/gh-repo-man --user brewtest")
    assert_match "Successfully cloned sample-repo", output
    assert_path_exists home/"projects"/"sample-repo"/".git"
  end
end
