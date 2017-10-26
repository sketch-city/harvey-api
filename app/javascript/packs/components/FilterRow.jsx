import React, { Component } from "react"
export default class FilterRow extends Component {
  constructor(props) {
    super(props)
    this.state = {
      filterShelter: "",
      filterCounty: "",
      filterAccepting: true
    }
  }
  render() {
    return (
      <div className="filters">
        <h1>Harvey Shelters</h1>
        <div>
          <label>County</label>
          <input
            type="text"
            value={this.state.filterCounty}
            onChange={e => this.setState({ filterCounty: e.target.value })}
            placeholder="by County"
          />
        </div>
        <div>
          <label>Shelter Name</label>
          <input
            type="text"
            value={this.state.filterShelter}
            onChange={e => this.setState({ filterShelter: e.target.value })}
            placeholder="by Shelter Name"
          />
        </div>
        <div>
          <label>
            Accepting?{" "}
            <input
              type="checkbox"
              checked={this.state.filterAccepting}
              onChange={e =>
                this.setState({ filterAccepting: e.target.checked })}
            />
          </label>
        </div>
        <div>
          <button
            className="button button-outline"
            onClick={() => this.props.searchRecords(this.state)}
          >
            Search
          </button>
        </div>
      </div>
    )
  }
}
