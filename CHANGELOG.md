## CHANGELOG

### Newer releases

Please see: https://github.com/NARKOZ/gitlab/releases

### 4.2.0 (13/07/2017)
- Use `url_encode` in all `Commit` resources (@grodowski)
- Fix `project_search` path for APIv4 (@edaubert)
- Add options to `Labels#create_label` (@hlidotbe)
- Add `Board` API support (@hlidotbe)
- `Award Emoji` API (@akkee)
- Subscribe and unsubscribe actions for labels (@akkee)
- Add `options` hash to `add_hook` method (@mltsy)
- Update repository files endpoint APIv4 (@mltsy)
- Update `Branch` docs and add `options` param to `protect_branch` (@mltsy)
- Fix and clarify `edit_project` option docs (@mltsy)
- Add `TODO` API (@akkee)
- Use `body` parameter to send POST data (@sr189)
- Add `Environments` module (@mltsy)
- Edit and Delete methods for `Notes` API (@akkee)
- Rename `branch_name` parameter to `branch` in `create_branch` & `create_commit` methods (@sr189)

### 4.1.0 (26/05/2017)
- Add appropriate Content-Type header (@mltsy)
- Add `Jobs` endpoint methods (@hjanuschka)
- Update `BuildTriggers` to v4 API and rename to `PipelineTriggers`. (@IgnoredAmbience)
- Add support for `keys` resource (@dirker)
- Remove version-lock for terminal-table (@SuperTux88)

### 4.0.0 (10/04/2017)
- Adds ability to create commits in a repository - (@logicminds)
- Remove Ruby 1.x support from the project - (@orta)
- Add `star_project` and `unstar_project` methods. (@connorshea)
- Lock terminal-table to prevent build failures on Ruby 1.9/2.0. (@connorshea)
- Update documentation to link to docs.gitlab.com instead of the GitHub mirror for GitLab CE. (@connorshea)
- Add method `share_project_with_group` (@danhalligan)
- Allow to retrieve `ssh_keys` for a specific user(@dirker)
- Allow issues to use NAMESPACE/REPO identifier (@brodock)
- Add issues subscribe/unsubscribe (@newellista)
- Add merge_requests subscribe/unsubscribe (@newellista)
- Updated `deploy_key` endpoints (@epintozzi)
- Add milestone/merge_requests (API V4 only) (@joren)
- Rename "git hook" to "push rule". (@asedge)
- Change project fork endpoint for v4 API. (@asedge)
- Block/unblock user now uses POST instead of PUT. (@asedge)
- Project ID can also be a string (namespace/project_name). (@bergholdt)
- Support pipeline. (@bergholdt)
- Add methods to disable and enable deploy keys on projects. (@buzzdeee)
- Add method to fetch issues a merge request will close. (@joren)
- Fix `get_file` and `file_contents` methods to work with APIv4. (@asedge)

### 3.7.0 (16/08/2016)

- Add in GitlabCI Runner support (@davidcollum)
- Implemented tags API methods (@jblackman)
- Expose response status when Gitlab raises an error. (@calavera)
- Add `build_artifacts` method (@nanofi)
- Add `user_search` method (@Dreeg)
- Added project git hook support (@liger1978)
- Add the ability to delete an issue (@dandunckelman)
- Add missing Build APIs (@edgemaster)
- Improve record table output to use Hash `id` field if it exists. (@asedge)
- Support for listing merge request notes (@dlukman)
- Update YARD so it can be formatted easier for the CLI. (@asedge)
- Add `options` to `build` method (@sanderhahn)
- Add `delete_group` method (@shadeslayer)
- Add `group_projects` method (@shadeslayer)
- Add `edit_merge_request_comment` (@hjanuschka)
- Add `merge_request_commits` method (@nomeaning777)
- Add method `edit_group_member` (@coder-hugo)
- New builds endpoints (@kmarcisz)
- Use `respond_to_missing?` instead of `respond_to?` (@tsigo)
- Added possibility to change emails of user (@azomazo)
- Added possibility to change services in the project (@azomazo)
- Update README.md (@walterheck)

### 3.6.1 (13/12/2015)

- Fixed CLI output for collections

### 3.6.0 (11/12/2015)

- Improved output of the CLI help (@thomasdarimont)
- Added `search_projects` alias for `project_search` method
- Added pagination and auto pagination support (@nanofi)

### 3.5.0 (26/11/2015)
- [a4f2150](https://github.com/NARKOZ/gitlab/commit/a4f21504a7288caace5b7433b49f49dc31e32b30) Add support for namespaces endpoint
- [3ad81a1](https://github.com/NARKOZ/gitlab/commit/3ad81a19a10b35ea422c0abcf08e6d03a325f4cd) Add missing "@" in doc. (@asedge)
- [fc34acb](https://github.com/NARKOZ/gitlab/commit/fc34acb6b475bb2555e4b035c11fdf42b3db4085) Add Gitlab::Client::Commits and rearrange methods and tests related to commits. (@asedge)
- [527089b](https://github.com/NARKOZ/gitlab/commit/527089b17fa7ed74a39b30dc6e8bb33482c1044b) Add commit status API, was added in Gitlab 8.1 (@dsander)
- [0a2f1db](https://github.com/NARKOZ/gitlab/commit/0a2f1dbe3efb66511dc836ef0ef884efedd70ef3) Add --json CLI parameter to output results as JSON
- [3f9cb62](https://github.com/NARKOZ/gitlab/commit/3f9cb625517c7294652139f2748e4bc7b98848cc) Adding sudo option for when forking a project (@gregoriomelo)
- [8dd964e](https://github.com/NARKOZ/gitlab/commit/8dd964ee743e051fade3137d8fac9bb387770150) Fix CLI configuration example comment line width to <= 80. (@asedge)
- [bbb8b61](https://github.com/NARKOZ/gitlab/commit/bbb8b61db46b32b8649956cb81d9a41e132493d4) Add comment for CLI configuration example. (@asedge)
- [30e96b9](https://github.com/NARKOZ/gitlab/commit/30e96b9444f7d60d4c0a56f57202c609497126eb) Update README.md (@raine)
- [d81f05b](https://github.com/NARKOZ/gitlab/commit/d81f05b80b7aaccef49641acfada3b2181f1633d) Change #handle_error method so it handles errors that are returned as an Array. (@asedge)
- [4c0395e](https://github.com/NARKOZ/gitlab/commit/4c0395ebc58c5a907489b6dc9dcac151e07b4dc8) Add Unprocessable error handler (@ondra-m)
- [3179bed](https://github.com/NARKOZ/gitlab/commit/3179bedc498b6c5577cc3c0b04633f67eb286ea9) Add block/unblock user. This API feature was added in GitLab 7.13 (@azomazo)
- [9946c7d](https://github.com/NARKOZ/gitlab/commit/9946c7d2a2c4261cbfc9c4a492b079c79abc2767) Check for specific exceptions in tests to suppress rspec warnings. (@asedge)
- [5e1c025](https://github.com/NARKOZ/gitlab/commit/5e1c025b8fdf723770c7c7ac0116acdf5cc9f2d5) Added support description option in create_group method (@azomazo)
- [46b657e](https://github.com/NARKOZ/gitlab/commit/46b657e47a29bc18f4122fff593a9eb58b73e4f1) deleting a gitlab project returns the string "true" (@tosmi)
- [cc3b489](https://github.com/NARKOZ/gitlab/commit/cc3b489cdeb3bd18b4ec841f80e76e74ddd0ce37) add development scripts (@NARKOZ)
- [24ad7fd](https://github.com/NARKOZ/gitlab/commit/24ad7fd2a1bd99eb468f1181d95c75fbec5d8fe0) Added specs edit_project, create_fork, create_user_with_username (@p404)
- [42e73a2](https://github.com/NARKOZ/gitlab/commit/42e73a2fde3e64dc8e3cf0ec73b8cfad88e43ca8) Added edit_project method to Projects module && updated the create_user method (@p404)
- [c9822f1](https://github.com/NARKOZ/gitlab/commit/c9822f1b61a8d7a5e855616e80e725730340cd48) Refactor create_user method (@p404)
- [6d7c4e7](https://github.com/NARKOZ/gitlab/commit/6d7c4e7c3285ee082513b3125346e6ed9c18b24b) Added create_fork method to Projects module (@p404)
- [54155b6](https://github.com/NARKOZ/gitlab/commit/54155b6c59d6e307744668cb3592ca98cf11d8f2) Add snippet_content method + tests. (@asedge)
- [cfff385](https://github.com/NARKOZ/gitlab/commit/cfff385b7f528223bf9ddc5f4177883e5ca56492) Remove executable permission on fixture file. (@asedge)
- [487a372](https://github.com/NARKOZ/gitlab/commit/487a372f7041d104975570747a63c9021881c952) Add RepositoryFiles#get_file method. (@asedge)
- [c9c05ad](https://github.com/NARKOZ/gitlab/commit/c9c05adee50828cc2e31048006cc95b5f2b9b7ce) Hide auth_token method from CLI/shell. (@asedge)
- [ef408a7](https://github.com/NARKOZ/gitlab/commit/ef408a7de0e677a568a66dbf212139aafc2e6186) Remove unnecessary require. (@asedge)
- [a2752d1](https://github.com/NARKOZ/gitlab/commit/a2752d1f5a01759a85d1e2003bb81c8e59cf85d3) Add some missing examples. (@asedge)
- [ac595af](https://github.com/NARKOZ/gitlab/commit/ac595af15a07601b3b657d4b4c1c479651aaa7d7) Add group_search method. (@asedge)
- [53a6671](https://github.com/NARKOZ/gitlab/commit/53a667184ed3640aefcb3f67836d37f58a504f24) Added Users#delete_user method (@cthulhu666)
- [a2360f0](https://github.com/NARKOZ/gitlab/commit/a2360f08019632c2660dbbc6753bd3094286b993) Add httparty ENV variable for CLI. Fixes #127. (@asedge)

### 3.4.0 (22/04/2015)
- [9acb83d](https://github.com/NARKOZ/gitlab/commit/9acb83d2d068720b07934f5152313dc22a2f6374) remove check for missing attributes
- [8896e2b](https://github.com/NARKOZ/gitlab/commit/8896e2b7d5e8df509d48a411fd4440e27ed13995) return false when response body is empty
- [a04f3af](https://github.com/NARKOZ/gitlab/commit/a04f3af2d7aa8eec60c4f044fdb148e45c1ca133) escape ref parameter for repo_file_contents
- [8dcfec5](https://github.com/NARKOZ/gitlab/commit/8dcfec5aaaff9ef1c12687c5f9ca90f6aed0f912) Add tests for project_search. (@asedge)
- [75ead81](https://github.com/NARKOZ/gitlab/commit/75ead813b4335bab2464b6af0fb776c3d746242f) Added :page and :per_page query options to snippet_notes method (@StephenOTT)
- [f9818cb](https://github.com/NARKOZ/gitlab/commit/f9818cb121c8eeb9197e66732fec30ab90deecad) Added :page and :per_page query options to issue_notes method (@StephenOTT)
- [f92d745](https://github.com/NARKOZ/gitlab/commit/f92d745f1f561955d8fcbed4e23b43bb92ace255) Added :page and :per_page query options to notes method (@StephenOTT)
- [d4c3f20](https://github.com/NARKOZ/gitlab/commit/d4c3f2052c844486cf2b99a5346af4cd3fc001c9) Add support for merge_request_changes (@dsander)
- [2253fba](https://github.com/NARKOZ/gitlab/commit/2253fbab0a915d23f30de04a90167a0c783f9a6b) Allow authenticating via oauth with the private_token (@dsander)
- [8b7bcb4](https://github.com/NARKOZ/gitlab/commit/8b7bcb478e168f5ce2c94b8633b33128c29252b9) add inspect method to ObjectifiedHash
- [257737c](https://github.com/NARKOZ/gitlab/commit/257737c80ca93a71dfb5f8d990e5de1423603dfc) add delete_branch (@marc-ta)
- [f6532d5](https://github.com/NARKOZ/gitlab/commit/f6532d5074e0bb0d06bc251fb43b73f49a7af17a) improve docs
- [5164e6d](https://github.com/NARKOZ/gitlab/commit/5164e6de544bc34c57c3444e0b63cf3aada23776) Adding options hash to milestone_issues method.
- [57fa92d](https://github.com/NARKOZ/gitlab/commit/57fa92d7eef96e84498fa005e7ab83abc2a41a2b) Added support to get milestone issues. (@pbendersky)
- [d604e58](https://github.com/NARKOZ/gitlab/commit/d604e58732ea08fb15acdc1be339535e34e68d73) Add create_merge_request_note
- [cea19b8](https://github.com/NARKOZ/gitlab/commit/cea19b8e607033700dcab4648c05ac398cfe9566) Add project_search method (@ey3ball)
- [d0ebd3b](https://github.com/NARKOZ/gitlab/commit/d0ebd3b3a0ed83fc62d2a2e22ba9aa29a99cdcb6) Catch SIGINT earlier during shell session. Fixes #111. (@asedge)
- [2133562](https://github.com/NARKOZ/gitlab/commit/21335623009553197b61826d9894a739de152665) Redo the actions_table to make it more readable. CLI can now display the same help as the Shell. Closes #106. (@asedge)
- [da18909](https://github.com/NARKOZ/gitlab/commit/da1890949fb9eb60c13ab670dd8428d27de1814b) Add some method documentation and small style fixes. (@asedge)
- [7e1b408](https://github.com/NARKOZ/gitlab/commit/7e1b408e48152df1ce6e2be74a653c3801a37c10) Authenticate via oauth an auth_token (@dsander)
- [adb28b3](https://github.com/NARKOZ/gitlab/commit/adb28b30dab47bd3a58eae697d40e4aa346ea2c8) Update create_merge_request doc to include :target_project_id parameter.  Closes #108. (@asedge)
- [525e913](https://github.com/NARKOZ/gitlab/commit/525e9131fe99a3f7396b547810e957058ab5a092) add ruby-2.2 to travis-ci
- [3671c89](https://github.com/NARKOZ/gitlab/commit/3671c89071d712ee71fa51cac67f3e0b9a28b03b) Save shell history when user presses Ctrl-d (@asedge)
- [c8e5f50](https://github.com/NARKOZ/gitlab/commit/c8e5f50684533e00550bfa4474062665000df28a) Hide httparty & httparty= methods from Gitlab.actions - just like endpoint, private_token, etc. (@asedge)
- [358deeb](https://github.com/NARKOZ/gitlab/commit/358deeb8ed849defe28c7cba84e1935d549fce22) Fix a regression with exception handling in shell. (@asedge)
- [9612ce3](https://github.com/NARKOZ/gitlab/commit/9612ce3b8274a385ce8c1fcd5ca5d0a0eba71c7e) Added support for repository files create, edit and remove. (@razielgn)
- [2203ad7](https://github.com/NARKOZ/gitlab/commit/2203ad7fcaa337da3d9700cbbc342d961be18eee) Fix headings in action_table. (@asedge)
- [b4dceb3](https://github.com/NARKOZ/gitlab/commit/b4dceb3d2d582682f3cb35ca63e41e237d222596) add CHANGELOG.md
- [e2bd91c](https://github.com/NARKOZ/gitlab/commit/e2bd91ccf488dfede7688801e54270da0d395a56) Small refactor of Gitlab::Help, Gitlab::Shell & Gitlab::CLI::Helpers. Add some new tests and refactor ones recently added. (@asedge)
- [bffd84f](https://github.com/NARKOZ/gitlab/commit/bffd84f4e9e37d056772536f33a52f40df0b7882) Refactor Gitlab::Help.  Add tests some. (@asedge)
- [9bd4f7a](https://github.com/NARKOZ/gitlab/commit/9bd4f7ad69614ee009c351811deee9eb2a6c3d05) Add test for Gitlab::Shell. (@asedge)
- [bc14ec5](https://github.com/NARKOZ/gitlab/commit/bc14ec5173e432ced601c108cae6eca56026d41e) Refactor of Gitlab::Shell to hopefully make it more readable & testable.  Wrote tests for some Gitlab::Shell & Gitlab::CLI::Helper methods.  Other minor improvements and refactors. (@asedge)

### 3.3.0 (22/12/2014)
- [42b4bc7](https://github.com/NARKOZ/gitlab/commit/42b4bc7b0e5e35f151ab61e27099606f0f38af31) fix docs and specs
- [04e39e0](https://github.com/NARKOZ/gitlab/commit/04e39e013a7a74f6101a97c3791da0594da232a3) ability to update hook triggers
- [6c66fe9](https://github.com/NARKOZ/gitlab/commit/6c66fe92a56cca58630a34ed3e7991517dd63604) remove useless check for available hook events
- [c4b981d](https://github.com/NARKOZ/gitlab/commit/c4b981dd69974aa7e1cb088c9b9fd44e0c0a9b54) add accept_merge_request method
- [51611fe](https://github.com/NARKOZ/gitlab/commit/51611fe669987cd9f4c1fac0ed96c743e391bbf2) Use endpoint instance var instead of base_uri class method. Fixes #94. (@asedge)
- [1ec8b38](https://github.com/NARKOZ/gitlab/commit/1ec8b38322657c3f97a60deb10dc08b828ba9875) test multiple clients
- [44d013a](https://github.com/NARKOZ/gitlab/commit/44d013af76535a2227678869148fb7a8195691df) Capture CTRL-C in Shell (@chrisdambrosio)
- [3cba3b2](https://github.com/NARKOZ/gitlab/commit/3cba3b2420d72d8aead0febf0ba3564c7615cf8c) Adding respond_to override to the ObjectifiedHash class so it properly responds to respond_to? calls (@koglinjg)
- [ce20c47](https://github.com/NARKOZ/gitlab/commit/ce20c4768c3e591b0cea72e8738371ab76d7289e) limit history file size - closes #93 (@chrisdambrosio)
- [1cf656f](https://github.com/NARKOZ/gitlab/commit/1cf656f7cf9f1821339b9e6ed711f6218cddbf0f) Save/load shell mode history - closes #79 (@chrisdambrosio)
- [727780b](https://github.com/NARKOZ/gitlab/commit/727780b8f282bb8fe461a54e558fe0775b4b36fd) HTTP proxy support - closes #52 (@chrisdambrosio)
- [e4ceb18](https://github.com/NARKOZ/gitlab/commit/e4ceb187aa5e47d20740676aea4f36c473ddd241) implement .file_contents (@chrisdambrosio)
- [0d0e7e0](https://github.com/NARKOZ/gitlab/commit/0d0e7e01bab1708cd85294788f9b9cca33a33ddb) Now must use YAML valid syntax in CLI or CLI Shell where Gitlab methods expect Hashes (usually in the form of options). (@asedge)
- [a7d0e0a](https://github.com/NARKOZ/gitlab/commit/a7d0e0a8c1c50c4ab43faccdb88f049f5b84a1cf) add CONTRIBUTING.md
- [1f4ef8e](https://github.com/NARKOZ/gitlab/commit/1f4ef8ed25ccd1bdbeccf677a0a94106903d0f24) improve docs
- [3a8d339](https://github.com/NARKOZ/gitlab/commit/3a8d33946adec71724304f661d70eb515a2f6848) Repository tree root level files (@semenyukdmitriy)
- [ddab89e](https://github.com/NARKOZ/gitlab/commit/ddab89e6aa9917d06cddd121aa486424753bdf84) Adds support for comments on commits (@jeroenj)
- [a7c18f1](https://github.com/NARKOZ/gitlab/commit/a7c18f1180157021ef8d24791f32a30511940fbf) Add labels api for list, create, edit and delete. (@artworx)
- [d9940d5](https://github.com/NARKOZ/gitlab/commit/d9940d5f4dfd8fdc4530b249b518e0d048dbfdbb) Support pagination in Gitlab.merge_request_comments (@cubiware)
- [13a550c](https://github.com/NARKOZ/gitlab/commit/13a550cb82a4775f3c72850dcd65e807abe46e69) Update tests for create_tags method so it more closely matches what will happen in Gitlab 7.5.0. (@asedge)
- [6d8a98f](https://github.com/NARKOZ/gitlab/commit/6d8a98f7930d2df5af19cc838eb95ae9c775e1a1) Add repo compare API (@zlx)
- [76e29e6](https://github.com/NARKOZ/gitlab/commit/76e29e632ce345ed17d69401dcb286dc85a951aa) Add support for annotated tag creation. Update tests for create_tag. (@asedge)
- [40295b8](https://github.com/NARKOZ/gitlab/commit/40295b8889c0094babffc81a5d7749d32b0fbda6) introduce HTTParty-configuration, fix #61 (@barraq)
- [916e8a7](https://github.com/NARKOZ/gitlab/commit/916e8a72371a097fa63065b05d3dca0be7bc9e93) Improved arg parsing for gitlab readline shell.  Other small fixes/improvements on regexes. (@asedge)
- [382fe71](https://github.com/NARKOZ/gitlab/commit/382fe71e3d509a57f736138ffbb673695577f709) Add missing documentation: :group_id, :namespace_id (@arioch)
- [c9f9662](https://github.com/NARKOZ/gitlab/commit/c9f9662a9b1116c838b523ed64c6abdb4aae4b8b) add exit command to shell

### 3.2.0 (22/06/2014)
- [fee67da](https://github.com/NARKOZ/gitlab/commit/fee67da36cdab7906004e7a060602eb342c8b946) Handling some error cases when calling for help. (@asedge)
- [7705b01](https://github.com/NARKOZ/gitlab/commit/7705b01c94d8833fb055ca072d34c0019c622caf) Adding online help for Gitlab::Shell using "ri" command.  I'm unsure if this is the best idea.  Some refactoring still needs to be done to remove duplicate code. (@asedge)
- [599deff](https://github.com/NARKOZ/gitlab/commit/599deffbe193aed420747be16516b29b8beeb31f) Fix output_table call in CLI. (@asedge)
- [4a5f81f](https://github.com/NARKOZ/gitlab/commit/4a5f81f0e605a89205c05a4baefdbf6d2331d667) Initial commit of Gitlab CLI shell. Tab completion for Gitlab.actions. (@asedge)
- [48ba2a1](https://github.com/NARKOZ/gitlab/commit/48ba2a178b0e3f206588ccd5aeed14e52d1ba269) fix specs after update to RSpec 3
- [a8284af](https://github.com/NARKOZ/gitlab/commit/a8284af9af017e0bf381347a534f9a2426e35d64) Add spec for project_events method (@hassaku)
- [8e8527c](https://github.com/NARKOZ/gitlab/commit/8e8527cc4743a11ea285072e11f1bb4e703757ff) Add method to get a list of project events (@hassaku)
- [8c2aa8f](https://github.com/NARKOZ/gitlab/commit/8c2aa8fc9f660696596639d458444bc00fe17f0c) Add create_tag method.  Add tests for new method. (@asedge)
- [cd5ae8b](https://github.com/NARKOZ/gitlab/commit/cd5ae8ba8aca5025a41ec1dd9fad70dae10c2fd3) clarify default config options

### 3.1.0 (22/05/2014)
- [16834bb](https://github.com/NARKOZ/gitlab/commit/16834bb178fa6bf6c7ec8b67bfedfdc32145769d) add info command to CLI
- [68aebb7](https://github.com/NARKOZ/gitlab/commit/68aebb76b24972b7d00a78f3d4f923fca009ba31) ability to delete a project
- [ac54e55](https://github.com/NARKOZ/gitlab/commit/ac54e55825d16373862fbbc176d6c9c2594dc593) set command arguments when no filters
- [23be13e](https://github.com/NARKOZ/gitlab/commit/23be13e87c3c99764fcb27393ce99d9cc05633b9) fix docs
- [1b298dc](https://github.com/NARKOZ/gitlab/commit/1b298dcd5f71321867ad2bd3c18522a7602357ad) fix ruby 1.9 compatibility
- [af92ff5](https://github.com/NARKOZ/gitlab/commit/af92ff546af578ba0753c254fabf73761553f4c8) add confirmation for destructive commands
- [b1602d2](https://github.com/NARKOZ/gitlab/commit/b1602d2f5ce0a614de48d5295654d0699fe69c0d) move methods related to CLI output to a separate module
- [4183a52](https://github.com/NARKOZ/gitlab/commit/4183a52ca6344d86aa152e189bc20c467c96c5a5) improve help message
- [0bba284](https://github.com/NARKOZ/gitlab/commit/0bba284e9447a4a6aa95990b65db5ae4d44ce989) add specs for CLI
- [5ec08bc](https://github.com/NARKOZ/gitlab/commit/5ec08bc0173e986e5979ca0c809d70002186f0cc) ability to filter CLI output
- [ba86169](https://github.com/NARKOZ/gitlab/commit/ba861692bae33cba8d22ac3beb223995a4df216c) add table output for multiple records
- [9cc540c](https://github.com/NARKOZ/gitlab/commit/9cc540c948bd71a70e3c1f6fc656e1bbde0dcb00) initial wrap-up of CLI
- [bee9745](https://github.com/NARKOZ/gitlab/commit/bee9745f2202f9dafd20b0edee185fe54f413cb2) include modules alphabetically
- [4963f16](https://github.com/NARKOZ/gitlab/commit/4963f16f3eb0a3f3a6dd7fbdc3b7f3aeab8d57cc) add special method that lists available actions for client
- [fe50c24](https://github.com/NARKOZ/gitlab/commit/fe50c24437ea2bd729044f30ef6afe8df1932f32) support environment variables
- [7a5d40c](https://github.com/NARKOZ/gitlab/commit/7a5d40ccd576abfb35c137f9e172821351d2dac8) eliminate ruby warning
- [b7fc447](https://github.com/NARKOZ/gitlab/commit/b7fc447211fe281e01f111f8a9fad08396fdfa4d) convert specs to new RSpec 2.14 syntax
- [471a643](https://github.com/NARKOZ/gitlab/commit/471a643a60a17ea9048615a2ac2d295e0682edd4) pass private token using HTTP headers
- [bbf6521](https://github.com/NARKOZ/gitlab/commit/bbf6521362d5af460c63a730d95f822e55160e82) fix users session spec
- [672a8d5](https://github.com/NARKOZ/gitlab/commit/672a8d54988dfafce4e3288a63f6cf67bf13c292) test Request class
- [3bf0363](https://github.com/NARKOZ/gitlab/commit/3bf03631769a419504f669bd3154953072701c61) set private_token param separately for each request
- [90760cd](https://github.com/NARKOZ/gitlab/commit/90760cdeb3dfaa7be5fdfa5eba792c3a8e617c57) Single commit and diff of a commit (@nanofi)
- [9b696d4](https://github.com/NARKOZ/gitlab/commit/9b696d4bd07c1ca5d8d41e6aaeb51f260393b789) pluralize module name: SystemHook -> SystemHooks
- [3b2cda9](https://github.com/NARKOZ/gitlab/commit/3b2cda9e974568f8d1d6bfebbf3f114686638f44) get rid of ruby argument prefix warning
- [0d6ca05](https://github.com/NARKOZ/gitlab/commit/0d6ca0565ee0eaf02ae077332f8082c8d939ce22) System Hook API (@nanofi)
- [29e31e0](https://github.com/NARKOZ/gitlab/commit/29e31e0a565a083c22401bb99b3cb28c8a43f5d6) Create branches.rb.  Move branch related actions there.  Add new methods for (un)protecting branches and creating new branches - which requires Gitlab 6.8-stable or newer. Added tests for new methods and fixed old tests looking for methods in old locations. (@asedge)
- [7f91a9a](https://github.com/NARKOZ/gitlab/commit/7f91a9a10dc8071d14d3ffaea001e32ac2f70180) Fixed: create project deploy key (@semenyukdmitriy)
- [b347574](https://github.com/NARKOZ/gitlab/commit/b3475743c624e7cc426ca099f0c86411ffaf6dd8) Project hooks: set events to trigger on (@semenyukdmitriy)
- [af49245](https://github.com/NARKOZ/gitlab/commit/af492453819678eca9f2a8e25b51d318e23d148c) Add merge_request_comments to get a MR's comments
- [2b9e659](https://github.com/NARKOZ/gitlab/commit/2b9e659afd646f8ffca7b323e40246096837eae7) Doc & test that update_merge_request can set state
- [45b0b9f](https://github.com/NARKOZ/gitlab/commit/45b0b9fc86016ba31e66b600172da6ace63f7a00) add 'to_hash' method for ObjectifiedHash
- [ce5294f](https://github.com/NARKOZ/gitlab/commit/ce5294f2ec74417626403595899a85c97d92318c) test against MRI 2.1.0
- [35aadef](https://github.com/NARKOZ/gitlab/commit/35aadef3f321d4d700c3f7926f2206ac241e7191) scope for projects api (@voanhduy1512)
- [7152c85](https://github.com/NARKOZ/gitlab/commit/7152c8520bf77f49385bb71ef82a574172500b00) Add edit_user method (@robertomiranda)

### 3.0.0 (22/10/2013)
- [da31730](https://github.com/NARKOZ/gitlab/commit/da3173016870d76aabbd43ee1b04e7348cbdbb1e) handle response code 405
- [3c18ad0](https://github.com/NARKOZ/gitlab/commit/3c18ad0d373b4647232be3bbc1ee88aed9a3bbfc) remove ruby 1.8 patch
- [3fca003](https://github.com/NARKOZ/gitlab/commit/3fca0033e8dabbefdbf50fc15713866521d0e1d3) re-implement handling of sudo requests
- [49c54a6](https://github.com/NARKOZ/gitlab/commit/49c54a67a8c1a67dd1f471c93e63c6dace329817) ability to paginate group members
- [8ba8361](https://github.com/NARKOZ/gitlab/commit/8ba8361d6fed3967986243a9c48871b79040bb51) fix compatibility with API v3; update docs
- [93e8b81](https://github.com/NARKOZ/gitlab/commit/93e8b81632067879d874a31e18ab48a50ccaf05c) prettify error message
- [1752997](https://github.com/NARKOZ/gitlab/commit/1752997f22586c76929c7396db8892fe930cb93a) Add methods to manage deployment keys (@sosedoff)
- [613dda8](https://github.com/NARKOZ/gitlab/commit/613dda8f7b42770635023137fb6844709ad77ffd) Add group api, removed user_teams api
- [8db4e88](https://github.com/NARKOZ/gitlab/commit/8db4e88ade68401e3e2dc26f8cc9b78a48a0f8ea) Update error_message to print request uri on response failure
- [dd33a2f](https://github.com/NARKOZ/gitlab/commit/dd33a2feaa96022d6bd3795fb861eaf57f554bfa) Adding a check_attributes method in order to verify that the correct parameters have been passed into create_merge_request and comment_merge_request. Updating tests. (@thomasbiddle)
- [6f4a170](https://github.com/NARKOZ/gitlab/commit/6f4a170191a401c7eaf97522c5b8e20970e90249) Adding tests for missing merge request api calls. (@thomasbiddle)
- [af42bcb](https://github.com/NARKOZ/gitlab/commit/af42bcb7c18b27db266efdf7c9645d795d691760) Adding support for creating, updating, and commenting on merge requests. (@thomasbiddle)
- [f7aac38](https://github.com/NARKOZ/gitlab/commit/f7aac3860169ce0d0268676dc278d8150e497df8) minor updates indicating support for creating public projects (@amacarthur)
- [44a090d](https://github.com/NARKOZ/gitlab/commit/44a090d983de178ebdc7f6cd9cdcc339d731f9ef) added apis for the admin of fork links (@amacarthur)
- [32f1419](https://github.com/NARKOZ/gitlab/commit/32f14199c53da58ce00572530a002f769c808024) Added sudo functionality
- [b7f6c48](https://github.com/NARKOZ/gitlab/commit/b7f6c48b65b4d18cc18919fab12cefa99826578e) Made 409's throw exceptions
- [d1f581f](https://github.com/NARKOZ/gitlab/commit/d1f581ff410ba5c42d03e2cf98efa548a6139b01) Fixed an issue with access level var in add team project
- [8a5d679](https://github.com/NARKOZ/gitlab/commit/8a5d679806bd1dc8501965450fe12d0e807fbd93) Add user_team api
- [b4444fc](https://github.com/NARKOZ/gitlab/commit/b4444fce8c3dd9f0caa2d1a096e61ce6373136fe) Adding user_teams api
- [53d7a8a](https://github.com/NARKOZ/gitlab/commit/53d7a8a86dfed63e56eeb16ea496bb7a82de337e) consistently refer to feature as "project for user" per documentation @ https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/projects.md#create-project-for-user (@dylee)
- [13457a4](https://github.com/NARKOZ/gitlab/commit/13457a4bfd67088e156489d09db148739a0af700) add support for POST /projects/user:user_id (@leesolutions)
- [5e556fa](https://github.com/NARKOZ/gitlab/commit/5e556fac11daa25d3d9683904cf8f96b8e0bb009) update travis-ci config with ruby-2.0
- [3b8513d](https://github.com/NARKOZ/gitlab/commit/3b8513da22c8d78ce6a284ac8a7a5eaad6ab349d) Groups api additions
- [f2ba111](https://github.com/NARKOZ/gitlab/commit/f2ba111dba70eca5346a880c541dafaf35d3332a) don't expose data in ObjectifiedHash
- [c6889eb](https://github.com/NARKOZ/gitlab/commit/c6889ebfd455892690c0cddc3b88c670d8723435) add specs for notes
- [e562a7d](https://github.com/NARKOZ/gitlab/commit/e562a7db8ffdf9ec947895800e9c5b7753b83bfb) bring support for ruby 1.8
- [63c3592](https://github.com/NARKOZ/gitlab/commit/63c3592af45aa0d01de09910f562a4f875d01f6a) Notes api for wall, issues, and snippets notes. List, read and create. (@jozefvaclavik)

### 2.2.0 (22/11/2012)
- [2ef4d48](https://github.com/NARKOZ/gitlab/commit/2ef4d48a0db13a7363973455c3c0ac9d2bf6df56) support merge requests API

### 2.1.0 (22/10/2012)
- [89541c1](https://github.com/NARKOZ/gitlab/commit/89541c1dddccf185318645bb2748541955f221b0) add ability to create a user
- [483b4f6](https://github.com/NARKOZ/gitlab/commit/483b4f6812e657e9ea12c0c89199654393554aa7) fix typos in docs
- [7632ecb](https://github.com/NARKOZ/gitlab/commit/7632ecba57c8fa3fe966ee6eb0055bb7752d79fd) add ability to list project snippets
- [6c5637e](https://github.com/NARKOZ/gitlab/commit/6c5637e526f73bfb1c7791b12756ebdadeae4e5f) add project_hook and edit_project_hook methods
- [5fcf078](https://github.com/NARKOZ/gitlab/commit/5fcf078437b62a39de7d49c6d92fd5cdf09c565c) Fix add_team_member (@mizzy)
- [6a0176a](https://github.com/NARKOZ/gitlab/commit/6a0176aac542eacd9df24da20a8994f9f70e6ed7) refactor Request class
- [53746d5](https://github.com/NARKOZ/gitlab/commit/53746d55f19f75e72b3439d25f7940ba66151c94) add convenient methods to change a state of an issue

### 2.0.0 (21/09/2012)
- [b47a324](https://github.com/NARKOZ/gitlab/commit/b47a324d616b7fa4e23160abae357887b9dde13f) initial implementation
